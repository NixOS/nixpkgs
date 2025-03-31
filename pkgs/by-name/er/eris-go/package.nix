{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitea,
  nixosTests,
  installShellFiles,
}:

buildGoModule rec {
  pname = "eris-go";
  version = "20241028";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "eris";
    repo = "eris-go";
    rev = version;
    hash = "sha256-v4pN+fVwYoir3GLneWhg/azsg7ifvcKAksoqDkkQGwk=";
  };

  vendorHash = "sha256-0BI4U9p4R7umyXtHAQBLa5t5+ni4dDndLNXgTIAMsqw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    install -D *.1.gz -t $man/share/man/man1
    installShellCompletion --cmd eris-go \
      --fish completions/eris-go.fish
  '';

  env.skipNetworkTests = true;

  passthru.tests = { inherit (nixosTests) eris-server; };

  meta = src.meta // {
    description = "Implementation of ERIS for Go";
    homepage = "https://codeberg.org/eris/eris-go";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ehmry ];
    mainProgram = "eris-go";
  };
}
