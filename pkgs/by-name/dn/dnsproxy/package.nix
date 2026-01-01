{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "dnsproxy";
<<<<<<< HEAD
  version = "0.78.2";
=======
  version = "0.78.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "AdguardTeam";
    repo = "dnsproxy";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-BZ9yiw5EoSLTZux/MC8MJLV9eifQYnz+ZBzAPZaxOPI=";
  };

  vendorHash = "sha256-NS7MsK7QXg8tcAytYd9FGvaYZcReYkO5ESPpLbzL0IQ=";
=======
    hash = "sha256-MZeRCsFUQicTj4yAefCUxKSsJTqTJX8lyp6qnFaYFcM=";
  };

  vendorHash = "sha256-PZPwTUGd2uzXkcnjvhPFG121/837GAe/pVfaeM0VYfY=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  ldflags = [
    "-s"
    "-w"
    "-X"
    "github.com/AdguardTeam/dnsproxy/internal/version.version=${finalAttrs.version}"
  ];

  # Development tool dependencies; not part of the main project
  excludedPackages = [ "internal/tools" ];

  doCheck = false;

  meta = {
    description = "Simple DNS proxy with DoH, DoT, and DNSCrypt support";
    homepage = "https://github.com/AdguardTeam/dnsproxy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      contrun
      diogotcorreia
    ];
    mainProgram = "dnsproxy";
  };
})
