{ lib
, buildGoModule
, fetchFromGitHub
, nix-update-script
}:

buildGoModule rec {
  pname = "scripthaus";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "scripthaus-dev";
    repo = "scripthaus";
    rev = "v${version}";
    hash = "sha256-ZWOSLkqjauONa+fKkagpUgWB4k+l1mzEEiC0RAMUmo0=";
  };

  vendorHash = "sha256-GUZNPLBgqN1zBzCcPl7TB9/4/Yk4e7K6I20nVaM6ank=";

  env.CGO_ENABLED = 1;

  ldflags = [ "-s" "-w" ];

  postInstall = ''
    mv $out/bin/cmd $out/bin/scripthaus
  '';

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex" "^(v[0-9.]+)$" ];
  };

  meta = with lib; {
    description = "Run bash, Python, and JS snippets from your Markdown files directly from the command-line";
    homepage = "https://github.com/scripthaus-dev/scripthaus";
    license = licenses.mpl20;
    maintainers = with maintainers; [ raspher ];
    mainProgram = "scripthaus";
  };
}
