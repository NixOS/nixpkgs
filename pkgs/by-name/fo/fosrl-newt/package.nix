{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildGoModule rec {
  pname = "newt";
<<<<<<< HEAD
  version = "1.8.1";
=======
  version = "1.5.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "fosrl";
    repo = "newt";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-ndgigIk/3/cPZaJHfxWh6XvtAJe3S57sEwNTMBH0lSE=";
  };

  vendorHash = "sha256-5Xr6mwPtsqEliKeKv2rhhp6JC7u3coP4nnhIxGMqccU=";
=======
    hash = "sha256-svMAMPK8f5cwIPzr0+WdoWzHDV1jtuO1Lm2oZIVHE6k=";
  };

  vendorHash = "sha256-wNdZEfPx12T0jvCEDkz04X8N6t/pNIOXWFSTHteeZYs=";

  postPatch = ''
    substituteInPlace main.go \
      --replace-fail "version_replaceme" "${version}"
  '';
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeInstallCheckInputs = [ versionCheckHook ];

  ldflags = [
    "-s"
    "-w"
<<<<<<< HEAD
    "-X=main.newtVersion=${version}"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  doInstallCheck = true;

  versionCheckProgramArg = [ "-version" ];

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    description = "Tunneling client for Pangolin";
    homepage = "https://github.com/fosrl/newt";
    changelog = "https://github.com/fosrl/newt/releases/tag/${src.tag}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      fab
      jackr
      sigmasquadron
<<<<<<< HEAD
      water-sucks
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    ];
    mainProgram = "newt";
  };
}
