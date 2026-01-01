{
  buildGoModule,
  fetchFromGitHub,
  lib,
  testers,
  kitex,
}:

buildGoModule (finalAttrs: {
  pname = "kitex";
<<<<<<< HEAD
  version = "0.15.3";
=======
  version = "0.15.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "cloudwego";
    repo = "kitex";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-ynWtLQjiBDPYQ8YgjdiGCR/dI5krLyFFdv4kyEcCRYI=";
  };

  vendorHash = "sha256-CldQslLyPOr8b6Mskuvoe+5AyXNxyLOmIjCw0vi73xk=";
=======
    hash = "sha256-1nEyjEnG58+5Xnxcd4XCyTTa17nJfeHr2KJCaPcazhE=";
  };

  vendorHash = "sha256-9o+9HVC6WRhKhAKnN6suumNBKS2y392A6vQCQYtRsfM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "tool/cmd/kitex" ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    ln -s $out/bin/kitex $out/bin/protoc-gen-kitex
    ln -s $out/bin/kitex $out/bin/thrift-gen-kitex
  '';

  passthru.tests.version = testers.testVersion {
    package = kitex;
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "High-performance and strong-extensibility Golang RPC framework";
    homepage = "https://github.com/cloudwego/kitex";
    license = lib.licenses.asl20;
    maintainers = [ ];
    mainProgram = "kitex";
  };
})
