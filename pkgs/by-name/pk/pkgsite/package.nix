{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule {
  pname = "pkgsite";
<<<<<<< HEAD
  version = "0-unstable-2025-12-23";
=======
  version = "0-unstable-2025-11-20";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "golang";
    repo = "pkgsite";
<<<<<<< HEAD
    rev = "1a3bd3c788fea11057a8e696fd274c4c3f3e952c";
    hash = "sha256-GnjzJhmH9mOBdpc+r3Hco0KFsTp4LMkbTn/oMBthemQ=";
  };

  vendorHash = "sha256-6wgJNDzUzSCkwzjqGwzpa63+0HoN5PapKxMBFBuu16M=";
=======
    rev = "84333735ffe124f7bd904805fd488b93841de49f";
    hash = "sha256-XYySnVvnNZr1tg46AoYBsmeT5y/StByWcQhnNOdoLJo=";
  };

  vendorHash = "sha256-Zv9kyBGLicSJlWD0/wv6ggteA+DttOb18/P5s91tJxE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  subPackages = [ "cmd/pkgsite" ];

  ldflags = [ "-s" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Official tool to extract and generate documentation for Go projects like pkg.go.dev";
    homepage = "https://github.com/golang/pkgsite";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ phanirithvij ];
    mainProgram = "pkgsite";
  };
}
