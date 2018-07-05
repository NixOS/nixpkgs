{ system ? builtins.currentSystem }:

with import ../lib/testing.nix { inherit system; };
with pkgs.lib;

let
  mkDemo = eths: difs: let
    longest = foldr max 0 (map (d: length d.difs) difs);
    enroller = (findFirst (d: (length d.difs) == longest) { node = ""; } difs).node;
  in listToAttrs (imap1 (num: name: {
    name = name;
    value = mkDemoSystem name num (name == enroller) eths difs;
  }) (unique (concatMap (e: e.nodes) eths)));

  mkDemoSystem = node: num: enroller: eths: difs: { config, pkgs, ... }: with pkgs.lib; let
    nodeEths = filter (eth: elem node eth.nodes) (enumerate eths);
    nodeDIFs = filter (dif: dif.node == node) difs;
    difExt = name: name + ".DIF";
    ipcpExt = name: toString name + ".IPCP";
    enumerate = imap1 (i: x: x // { inherit i; });
    numberOf = x: xs: findFirst (i: i > 0) 0 (imap1 (i: v: if v == x then i else 0) xs);
  in {
    virtualisation.vlans = range 1 (length nodeEths);
    networking = {
      firewall.enable = false;
      useDHCP = false;
      localCommands = concatStringsSep "\n" (imap1 (i: eth: "ip link set dev eth${toString i} up") nodeEths);
      rina.rlite = {
        enable = true;
        difs = listToAttrs (map (dif: {
          name = difExt dif.name;
          value = {
            lowerDIFs = map difExt dif.difs;
            policyParams.addralloc.nack-wait-secs = 1;
            policyParams.enrollment.keepalive = 10;
          };
        }) nodeDIFs);
        ipcps =
          map (eth: with eth; {
            type = "shim-eth";
            apName = "${name}.${ipcpExt num}";
            difName = difExt name;
            params.netdev = "eth${toString (numberOf eth.name (map (e: e.name) nodeEths))}";
          }) nodeEths ++
          map (dif: with dif; {
            type = "normal";
            apName = "${name}.${ipcpExt num}";
            difName = difExt name;
            registerAt = map (eth: difExt eth.name) nodeEths;
            enrollerEnable = enroller;
          }) nodeDIFs;
      };
    };
    systemd.services.rina-echo-async = {
      description = "RINA echo server";
      serviceConfig.ExecStart = "${pkgs.rlite}/bin/rina-echo-async -z rina-echo-async.${node} -l -d ${(head nodeDIFs).name}.DIF";
    };
    systemd.services.rinaperf = {
      description = "RINA network throughput and latency performance measurement";
      serviceConfig.ExecStart = "${pkgs.rlite}/bin/rinaperf -z rinaperf.${node} -l -d ${(head nodeDIFs).name}.DIF";
    };
  };

  testCases = {
    console = {
      name = "uipcps-connection";
      machine = { config, pkgs, ... }: {
        networking.rina.rlite.enable = true;
      };
      testScript = ''
        startAll;
        $machine->waitForUnit("network.target");
        $machine->succeed("rlite-ctl ipcps-show");
      '';
    };

    # Basic test with two nodes and eth shim
    shim-eth-dif-echo-2 = let
      eths = [ { name = "ethAB"; nodes = [ "a" "b" ]; } ];
      difs = [ { name = "normal"; node = "a"; difs = [ "ethAB" ]; }
               { name = "normal"; node = "b"; difs = [ "ethAB" ]; } ];
    in {
      name = "shim-eth-dif-echo-2";
      nodes = mkDemo eths difs;
      testScript = { nodes, ... }:
        ''
          startAll;

          $a->waitForUnit("network.target");
          $b->waitForUnit("network.target");

          print $b->succeed("rlite-ctl ipcp-enroll-retry normal.2.IPCP normal.DIF ethAB.DIF normal.1.IPCP") . "\n";

          print $a->succeed("rlite-ctl ipcps-show; rlite-ctl flows-show") . "\n";

          # Test echo
          $a->succeed("systemctl start rina-echo-async");
          $a->waitForUnit("rina-echo-async.service");
          print $b->succeed("rina-echo-async -z rina-echo-async.a -d normal.DIF") . "\n";
        '';
    };

    # Three nodes
    shim-eth-dif-echo-3 = let
      eths = [ { name = "rb1"; nodes = [ "a" "b" ]; }
               { name = "rb2"; nodes = [ "b" "c" ]; } ];
      difs = [ { name = "n1"; node = "a"; difs = [ "rb1" ]; }
               { name = "n1"; node = "b"; difs = [ "rb1" "rb2" ]; }
               { name = "n1"; node = "c"; difs = [ "rb2" ]; } ];
    in {
      name = "shim-eth-dif-echo-3";
      nodes = mkDemo eths difs;
      testScript = { nodes, ... }:
        ''
          startAll;

          $a->waitForUnit("network.target");
          $b->waitForUnit("network.target");
          $c->waitForUnit("network.target");

          print $a->succeed("rlite-ctl ipcp-enroll-retry n1.1.IPCP n1.DIF rb1.DIF n1.2.IPCP") . "\n";
          print $c->succeed("rlite-ctl ipcp-enroll-retry n1.3.IPCP n1.DIF rb2.DIF n1.2.IPCP") . "\n";

          print $b->succeed("rlite-ctl ipcps-show; rlite-ctl flows-show") . "\n";

          # Echo server
          $a->succeed("systemctl start rina-echo-async");
          $a->waitForUnit("rina-echo-async.service");

          # Test echo
          print $c->succeed("rina-echo-async -z rina-echo-async.a -d n1.DIF") . "\n";
        '';
    };

    rinaperf = let
      eths = [ { name = "ethAB"; nodes = [ "a" "b" ]; } ];
      difs = [ { name = "normal"; node = "a"; difs = [ "ethAB" ]; }
               { name = "normal"; node = "b"; difs = [ "ethAB" ]; } ];
    in {
      name = "rinaperf";
      nodes = mkDemo eths difs;
      testScript = { nodes, ... }:
        ''
          startAll;

          $a->waitForUnit("network.target");
          $b->waitForUnit("network.target");

          $b->succeed("rlite-ctl ipcp-enroll-retry normal.2.IPCP normal.DIF ethAB.DIF normal.1.IPCP");

          # Start rinaperf server
          $b->succeed("systemctl start rinaperf");
          $b->waitForUnit("rinaperf.service");
          # fixme: fails
          print $a->execute("rinaperf -p 3 -t ping -d normal.DIF") . "\n";
        '';
    };
  };

in mapAttrs (const (attrs: makeTest (attrs // {
  name = "${attrs.name}-rlite";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ rvl ];
  };
}))) testCases
