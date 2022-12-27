{ lib
, buildGoModule
, fetchFromGitHub
, buildNpmPackage
}:

let
  pname = "authelia";
  version = "4.37.5";

  src = fetchFromGitHub {
    owner = "authelia";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-xsdBnyPHFIimhp2rcudWqvVR36WN4vBXbxRmvgqMcDw=";
  };

  web = buildNpmPackage {
    inherit src version;

    pname = "authelia-web";
    sourceRoot = "source/web";

    patches = [
      ./vite.config.ts.patch
    ];

    postPatch = ''
      cp ${./package-lock.json} ./package-lock.json
    '';

    npmDepsHash = "sha256-yMFatBAWLUJkVGTVOxtBqc1/W0XTIH8RqhmwRgNq8w0=";

    npmFlags = [ "--legacy-peer-deps" ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share
      mv dist $out/share/authelia-web

      runHook postInstall
    '';
  };

in

buildGoModule rec {
  inherit src pname version;

  vendorSha256 = "sha256-mzGE/T/2TT4+7uc2axTqG3aeLMnt1r9Ya7Zj2jIkw/w=";

  preBuild = ''
    rm -r internal/server/public_html/*

    cp -r ${web}/share/authelia-web/* internal/server/public_html/
    cp -r ${src}/api internal/server/public_html
  '';

  subPackages = [ "cmd/authelia" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/authelia/authelia/v4/internal/utils.BuildBranch=v${version}"
    "-X github.com/authelia/authelia/v4/internal/utils.BuildTag=${version}"
  ];

  postInstall = ''
    mkdir -p $out/etc/authelia
    cp ${src}/config.template.yml $out/etc/authelia/configuration.yml
'';

  meta = with lib; {
    description = "The Single Sign-On Multi-Factor portal for web apps";
    homepage = "https://github.com/authelia/authelia";
    license = licenses.asl20;
    maintainers = with maintainers; [ dit7ya ];
  };
}
