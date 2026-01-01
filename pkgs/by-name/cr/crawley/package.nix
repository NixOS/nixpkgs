{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "crawley";
<<<<<<< HEAD
  version = "1.7.16";
=======
  version = "1.7.15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "s0rg";
    repo = "crawley";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-/94ynxbH06JFzx3TZDRxvx9inbP+xiOVOqRxpopocjE=";
=======
    hash = "sha256-fVS7/W2M97IeVpoayqYImkgiQC5A96qklt53GDsIxfc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ installShellFiles ];

<<<<<<< HEAD
  vendorHash = "sha256-d6m4HFhTUzMMCNpv3WxoPGTF8Erqi0980w+MA2PoZ9w=";
=======
  vendorHash = "sha256-SaemEPcXc73G1wwxQ9/LbQV5fRd55pfd504F4PpAWVM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-w"
    "-s"
  ];

  postInstall = ''
    installShellCompletion --cmd crawley \
      --bash <(echo "complete -C $out/bin/crawley crawley") \
      --zsh <(echo "complete -o nospace -C $out/bin/crawley crawley")
  '';

<<<<<<< HEAD
  meta = {
    description = "Unix-way web crawler";
    homepage = "https://github.com/s0rg/crawley";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ltstf1re ];
=======
  meta = with lib; {
    description = "Unix-way web crawler";
    homepage = "https://github.com/s0rg/crawley";
    license = licenses.mit;
    maintainers = with maintainers; [ ltstf1re ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "crawley";
  };
}
