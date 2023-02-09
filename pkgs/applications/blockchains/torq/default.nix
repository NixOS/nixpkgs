{ lib
, buildGoModule
, buildNpmPackage
, fetchFromGitHub
}:

let
  pname = "torq";
  version = "0.17.3";

  src = fetchFromGitHub {
    owner = "lncapital";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fqHJZi1NQCrZqsa+N+FVYZ8s9o0D555Sqn5qNlJ1MmI=";
  };

  web = buildNpmPackage {
    pname = "${pname}-frontend";
    inherit version;
    src = "${src}/web";
    npmDepsHash = "sha256-8mUfTFzPjQlQvhC3zZf+WruDBkYnmGt3yckNi0CPWs0=";

    # copied from upstream Dockerfile
    npmInstallFlags = [ "--legacy-peer-deps" ];
    TSX_COMPILE_ON_ERROR="true";
    ESLINT_NO_DEV_ERRORS="true";

    # override npmInstallHook, we only care about the build/ directory
    installPhase = ''
      mkdir $out
      cp -r build $out/
    '';
  };
in
buildGoModule rec {
  inherit pname version src;

  vendorHash = "sha256-HETN2IMnpxnTyg6bQDpoD0saJu+gKocdEf0VzEi12Gs=";

  subPackages = [ "cmd/torq" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/lncapital/torq/build.version=v${version}"
  ];

  postInstall = ''
    ln -s ${web} $out/web
  '';

  meta = with lib; {
    description = "Capital management tool for lightning network nodes";
    license = licenses.mit;
    homepage = "https://github.com/lncapital/torq";
    maintainers = with maintainers; [ mmilata prusnak ];
  };
}
