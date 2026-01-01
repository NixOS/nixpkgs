{
  buildGoModule,
  fetchFromGitHub,
  lib,
}:

buildGoModule rec {
  pname = "go-audit";
<<<<<<< HEAD
  version = "1.2.1";
=======
  version = "1.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "slackhq";
    repo = "go-audit";
    rev = "v${version}";
<<<<<<< HEAD
    sha256 = "sha256-VzxFhaeETmhjYWBLQil10OhV4k8w6EHfV0qnun73gb0=";
  };

  vendorHash = "sha256-g5NP5QY8kNPQLLT9GGqHIQXkaBoZ+Wqna7KknCIwBNM=";
=======
    sha256 = "sha256-Li/bMgl/wj9bHpXW5gwWvb7BvyBPzeLCP979J2kyRCM=";
  };

  vendorHash = "sha256-JHimXGsUMAQqCutREsmtgDIf6Vda+it0IL3AfS86omU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # Tests need network access
  doCheck = false;

<<<<<<< HEAD
  meta = {
    description = "Alternative to the auditd daemon";
    homepage = "https://github.com/slackhq/go-audit";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
    platforms = lib.platforms.linux;
=======
  meta = with lib; {
    description = "Alternative to the auditd daemon";
    homepage = "https://github.com/slackhq/go-audit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    platforms = platforms.linux;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "go-audit";
  };
}
