{
  lib,
  fetchFromGitHub,
  installShellFiles,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "snow-plow";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "JeanCASPAR";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-8S47yuG0xaKxBE8hVt3C6R7Bes6I/ambRwY0nqMyzfY=";
  };

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    mkdir $out/artifacts
    pushd $out/artifacts

    $out/bin/snow-plow gen-man
    for shell in bash fish zsh; do
      $out/bin/snow-plow gen-completion $shell
    done
    popd

    installManPage $out/artifacts/*.1
    installShellCompletion \
      --cmd snow-plow \
      --bash $out/artifacts/snow-plow.bash \
      --fish $out/artifacts/snow-plow.fish \
      --zsh $out/artifacts/_snow-plow

    rm -r $out/artifacts
  '';

  cargoHash = "sha256-y8o3rn6+0Q/mDfi31sPYGynp4kMF5yFAWYp6vQgQEJc=";

  meta = {
    description = "Utility to update several flakes with one command, to improve sharing of dependencies on your computer";
    homepage = "https://github.com/JeanCASPAR/snow-plow";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jthulhu ];
    mainProgram = "snow-plow";
  };
}
