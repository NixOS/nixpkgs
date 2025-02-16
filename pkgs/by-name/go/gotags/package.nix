{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch,
}:

buildGoModule rec {
  pname = "gotags";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "jstemmer";
    repo = pname;
    rev = "4c0c4330071a994fbdfdff68f412d768fbcca313";
    hash = "sha256-cHTgt+zW6S6NDWBE6NxSXNPdn84CLD8WmqBe+uXN8sA=";
  };

  vendorHash = null;

  patches = [
    # Add Go Modules support
    (fetchpatch {
      url = "https://github.com/jstemmer/gotags/commit/9146999bce9a88e15b5f123d1aa1613926dd9a9c.patch";
      hash = "sha256-6v/Ws15y50S6iCI1c0kEw5WHSg+1WqVT4mwdQKoi5G8=";
    })
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  meta = with lib; {
    description = "ctags-compatible tag generator for Go";
    mainProgram = "gotags";
    homepage = "https://github.com/jstemmer/gotags";
    license = licenses.mit;
    maintainers = with maintainers; [ urandom ];
  };
}
