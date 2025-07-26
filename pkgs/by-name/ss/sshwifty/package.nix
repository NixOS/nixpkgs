{
  lib,
  buildGoModule,
  buildNpmPackage,
  fetchFromGitHub,
  go,
}:

let
  version = "0.3.24-beta-release";

  sshwifty-ui = buildNpmPackage {
    pname = "sshwifty-ui";
    inherit version;

    src = fetchFromGitHub {
      owner = "nirui";
      repo = "sshwifty";
      rev = version;
      hash = "sha256-av3L8trsPhE4k0TAuH5+ph7eWExmvkBsJkiTBdKxkYg=";
    };

    npmDepsHash = "sha256-6mV7pX6JOCouMWQgOgd7FvLcdwotS7Iz6I57mFqbsW8=";

    npmBuildScript = "generate";

    postInstall = ''
      for i in static_pages static_pages.go; do
        cp -r application/controller/$i \
          $out/lib/node_modules/sshwifty-ui/application/controller
      done
    '';

    nativeBuildInputs = [ go ];
  };
in
buildGoModule rec {
  pname = "sshwifty";
  inherit version;

  src = sshwifty-ui + "/lib/node_modules/sshwifty-ui";

  vendorHash = "sha256-tmbAsN0T1rXGvLWlx7c7AKnq4dquSPmfjaRxn3+ve+k=";

  ldflags = [
    "-s -w -X github.com/nirui/sshwifty/application.version=${version}"
  ];

  postInstall = ''
    find $out/bin ! -name sshwifty -type f -exec rm -rf {} \;
  '';

  meta = {
    description = "WebSSH & WebTelnet client";
    homepage = "https://github.com/nirui/sshwifty";
    license = lib.licenses.agpl3Only;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "sshwifty";
  };
}
