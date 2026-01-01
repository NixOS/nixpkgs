{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "der-ascii";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "google";
    repo = "der-ascii";
    rev = "v${version}";
    sha256 = "sha256-i4rNeNDE7bIsO04haMKsbJmyvQRhhEt3I7UxmfTtL78=";
  };
  vendorHash = null;

  ldflags = [
    "-s"
    "-w"
  ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = ''
      Small human-editable language to emit DER or BER encodings of ASN.1
      structures and malformed variants of them
    '';
    homepage = "https://github.com/google/der-ascii";
<<<<<<< HEAD
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
=======
    license = licenses.asl20;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      alexshpilkin
      cpu
      hawkw
    ];
    mainProgram = "ascii2der"; # has stable output, unlike its inverse
  };
}
