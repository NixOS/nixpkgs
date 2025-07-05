{
  name = "librechat";

  nodes.machine = {
    # Run this test with NIXPKGS_ALLOW_UNFREE=1
    services.mongodb.enable = true;
    services.librechat = {
      enable = true;
      env = {
        # The following were randomly generated with https://www.librechat.ai/toolkit/creds_generator
        CREDS_KEY = "6d6deb03cdfb27ea454f6b9ddd42494bdce4af25d50d8aee454ddce583690cc5";
        CREDS_IV = "7c09a571f65ac793611685cc9ab1dbe7";
        JWT_SECRET = "29c4dc7f7de15306accf5eddb4cb8a70eb233d9fba4301f8f47f14c8c047ac81";
        JWT_REFRESH_SECRET = "f2c1685561f2f570b3e7955df267b5c602ee099f14dc5caa0dacc320580ea180";
        MONGO_URI = "mongodb://localhost:27017";
      };
    };
  };

  testScript = ''
    machine.start()

    machine.wait_for_unit("librechat.service")
    machine.wait_for_open_port(3080)

    machine.succeed("curl --fail http://localhost:3080/")

    machine.shutdown()
  '';
}
