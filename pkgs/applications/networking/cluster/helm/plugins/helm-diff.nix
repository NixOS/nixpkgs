{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "helm-diff";
<<<<<<< HEAD
  version = "3.8.1";
=======
  version = "3.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "databus23";
    repo = pname;
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-x3tTHiuw0CtvsOCB7oPd9EB+B5T1m6Hn7O1CriYahuA=";
  };

  vendorHash = "sha256-2tiBFS3gvSbnyighSorg/ar058ZJmiQviaT13zOS8KA=";
=======
    sha256 = "sha256-bG1i6Tea7BLWuy5cd3+249sOakj2LfAZLphtjMLdlug=";
  };

  vendorSha256 = "sha256-80cTeD+rCwKkssGQya3hMmtYnjia791MjB4eG+m5qd0=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  ldflags = [ "-s" "-w" "-X github.com/databus23/helm-diff/v3/cmd.Version=${version}" ];

  # NOTE: Remove the install and upgrade hooks.
  postPatch = ''
    sed -i '/^hooks:/,+2 d' plugin.yaml
  '';

  postInstall = ''
    install -dm755 $out/${pname}
    mv $out/bin $out/${pname}/
    mv $out/${pname}/bin/{helm-,}diff
    install -m644 -Dt $out/${pname} plugin.yaml
  '';

  meta = with lib; {
    description = "A Helm plugin that shows a diff";
    homepage = "https://github.com/databus23/helm-diff";
    license = licenses.asl20;
    maintainers = with maintainers; [ yurrriq ];
  };
}
