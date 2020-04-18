import ./make-test-python.nix {

  machine = {
    networking.namespaces = [ "alice" "bob" ];

    containers.alice = {
      autoStart = true;
      networkNamespace = "alice";
      config = { };
    };

    containers.bob = {
      autoStart = true;
      networkNamespace = "bob";
      config = { };
    };
  };

  testScript =
    ''
      import json


      def link_exists(name, links):
          return len([link for link in json.loads(links) if link["ifname"] == name]) == 1


      machine.wait_for_unit("default.target")


      with subtest("namespaces created"):
          assert "alice" in machine.succeed("ip netns"), "alice: missing network namespace"
          assert "bob" in machine.succeed("ip netns"), "bob: missing network namespace"


      with subtest("alice is created in the correct netns"):
          machine.succeed("ip -n alice link add alice_nic type dummy")
          links = machine.succeed("nixos-container run alice -- ip -j link")
          assert link_exists("alice_nic", links)


      with subtest("bob is created in the correct netns"):
          machine.succeed("ip -n bob link add bob_nic type dummy")
          links = machine.succeed("nixos-container run bob -- ip -j link")
          assert link_exists("bob_nic", links)
    '';
}
