{
  buildGoModule,
  fetchFromGitHub,
  lib,
<<<<<<< HEAD
  yq-go,
  nix-update-script,
}:

let
  version = "1.0.3";
in
buildGoModule {
  pname = "helm-unittest";
  inherit version;
=======
}:

buildGoModule rec {
  pname = "helm-unittest";
  version = "0.7.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "helm-unittest";
    repo = "helm-unittest";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-wArRsC52ga485rpm8ns99NY/qUZ/FImK4C/L1q460HI=";
  };

  vendorHash = "sha256-dkAzmFvLbhbIYCKsk1+TfckdNkNh6OkpDabJDDSwXJM=";
=======
    rev = "v${version}";
    hash = "sha256-RWucFZlyVYV5pHFGP7x5I+SILAJ9k12R7l5o7WKGS/c=";
  };

  vendorHash = "sha256-tTM9n/ahtAJoQt0fwf1jrSokWER+cOnpPX7NTNrhKc4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/helm-unittest
    mv $out/bin/helm-unittest $out/helm-unittest/untt
    rmdir $out/bin
    install -m644 -Dt $out/helm-unittest plugin.yaml
  '';

<<<<<<< HEAD
  nativeCheckInputs = [
    yq-go
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "BDD styled unit test framework for Kubernetes Helm charts as a Helm plugin";
    homepage = "https://github.com/helm-unittest/helm-unittest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      booxter
      yurrriq
    ];
=======
  meta = with lib; {
    description = "BDD styled unit test framework for Kubernetes Helm charts as a Helm plugin";
    homepage = "https://github.com/helm-unittest/helm-unittest";
    license = licenses.mit;
    maintainers = with maintainers; [ yurrriq ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
