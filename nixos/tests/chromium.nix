{ system ? builtins.currentSystem
, pkgs ? import ../.. { inherit system; }
, channelMap ? {
    stable = pkgs.chromium;
    beta   = pkgs.chromiumBeta;
    dev    = pkgs.chromiumDev;
  }
}:

with import ../lib/testing.nix { inherit system; };
with pkgs.lib;

mapAttrs (channel: chromiumPkg: makeTest rec {
  name = "chromium-${channel}";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ aszlig ];
  };

  enableOCR = true;

  machine.imports = [ ./common/x11.nix ];
  machine.virtualisation.memorySize = 2047;
  machine.environment.systemPackages = [ chromiumPkg ];

  startupHTML = pkgs.writeText "chromium-startup.html" ''
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8">
    <title>Chromium startup notifier</title>
    </head>
    <body onload="javascript:document.title='startup done'">
      <img src="file://${pkgs.fetchurl {
        url = "http://nixos.org/logo/nixos-hex.svg";
        sha256 = "0wxpp65npdw2cg8m0cxc9qff1sb3b478cxpg1741d8951g948rg8";
      }}" />
    </body>
    </html>
  '';

  testScript = let
    xdo = name: text: let
      xdoScript = pkgs.writeText "${name}.xdo" text;
    in "${pkgs.xdotool}/bin/xdotool '${xdoScript}'";
  in ''
    sub createNewWin {
      $machine->nest("creating a new Chromium window", sub {
        $machine->execute("${xdo "new-window" ''
          search --onlyvisible --name "startup done"
          windowfocus --sync
          windowactivate --sync
        ''}");
        $machine->execute("${xdo "new-window" ''
          key Ctrl+n
        ''}");
      });
    }

    sub closeWin {
      Machine::retry sub {
        $machine->execute("${xdo "close-window" ''
          search --onlyvisible --name "new tab"
          windowfocus --sync
          windowactivate --sync
        ''}");
        $machine->execute("${xdo "close-window" ''
          key Ctrl+w
        ''}");
        for (1..20) {
          my ($status, $out) = $machine->execute("${xdo "wait-for-close" ''
            search --onlyvisible --name "new tab"
          ''}");
          return 1 if $status != 0;
          $machine->sleep(1);
        }
      }
    }

    sub waitForNewWin {
      my $ret = 0;
      $machine->nest("waiting for new Chromium window to appear", sub {
        for (1..20) {
          my ($status, $out) = $machine->execute("${xdo "wait-for-window" ''
            search --onlyvisible --name "new tab"
            windowfocus --sync
            windowactivate --sync
          ''}");
          if ($status == 0) {
            $ret = 1;
            last;
          }
          $machine->sleep(1);
        }
      });
      return $ret;
    }

    sub createAndWaitForNewWin {
      for (1..3) {
        createNewWin;
        return 1 if waitForNewWin;
      }
      die "new window didn't appear within 60 seconds";
    }

    sub testNewWin {
      my ($desc, $code) = @_;
      createAndWaitForNewWin;
      subtest($desc, $code);
      closeWin;
    }

    $machine->waitForX;

    my $url = "file://${startupHTML}";
    my $args = "--user-data-dir=/tmp/chromium-${channel}";
    $machine->execute(
      "ulimit -c unlimited; ".
      "chromium $args \"$url\" & disown"
    );
    $machine->waitForText(qr/Type to search or enter a URL to navigate/);
    $machine->waitUntilSucceeds("${xdo "check-startup" ''
      search --sync --onlyvisible --name "startup done"
      # close first start help popup
      key -delay 1000 Escape
      windowfocus --sync
      windowactivate --sync
    ''}");

    createAndWaitForNewWin;
    $machine->screenshot("empty_windows");
    closeWin;

    $machine->screenshot("startup_done");

    testNewWin "check sandbox", sub {
      $machine->succeed("${xdo "type-url" ''
        search --sync --onlyvisible --name "new tab"
        windowfocus --sync
        type --delay 1000 "chrome://sandbox"
      ''}");

      $machine->succeed("${xdo "submit-url" ''
        search --sync --onlyvisible --name "new tab"
        windowfocus --sync
        key --delay 1000 Return
      ''}");

      $machine->screenshot("sandbox_info");

      $machine->succeed("${xdo "submit-url" ''
        search --sync --onlyvisible --name "sandbox status"
        windowfocus --sync
      ''}");
      $machine->succeed("${xdo "submit-url" ''
        key --delay 1000 Ctrl+a Ctrl+c
      ''}");

      my $clipboard = $machine->succeed("${pkgs.xclip}/bin/xclip -o");
      die "sandbox not working properly: $clipboard"
      unless $clipboard =~ /namespace sandbox.*yes/mi
          && $clipboard =~ /pid namespaces.*yes/mi
          && $clipboard =~ /network namespaces.*yes/mi
          && $clipboard =~ /seccomp.*sandbox.*yes/mi
          && $clipboard =~ /you are adequately sandboxed/mi;
    };

    $machine->shutdown;
  '';
}) channelMap
