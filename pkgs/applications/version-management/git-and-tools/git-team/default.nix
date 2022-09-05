{ lib
, buildGoModule
, fetchFromGitHub
, fetchpatch
, installShellFiles
}:

buildGoModule rec {
  pname = "git-team";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "hekmekk";
    repo = "git-team";
    rev = "v${version}";
    hash = "sha256-pHKfehPyy01uVN6kjjPGtdkltw7FJ+HmIlwGs4iRhVo=";
  };

  patches = [
    (fetchpatch {
      name = "1-update-dependencies-for-go-1.18.patch";
      url = "https://github.com/hekmekk/git-team/commit/d8632d9938379293521f9b3f2a93df680dd13a31.patch";
      hash = "sha256-hlmjPf3qp8WPNSH+GgkqATDiKIRzo+t81Npkptw8vgI=";
    })
    (fetchpatch {
      name = "2-update-dependencies-for-go-1.18.patch";
      url = "https://github.com/hekmekk/git-team/commit/f6acc96c2ffe76c527f2f2897b368cbb631d738c.patch";
      hash = "sha256-Pe+UAK9N1NpXhFGYv9l1iZ1/fCCqnT8OSgKdt/vUqO4=";
    })
    (fetchpatch {
      name = "3-update-dependencies-for-go-1.18.patch";
      url = "https://github.com/hekmekk/git-team/commit/2f38137298e4749a8dfe37e085015360949e73ad.patch";
      hash = "sha256-+6C8jp/qwYVmbL+SpV9FJIVyBRvX4tXBcoHMB//nNTk=";
    })
  ];

  vendorSha256 = "sha256-GdwksPmYEGTq/FkG/rvn3o0zMKU1cSkpgZ+GrfVgLWM=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    go run main.go --generate-man-page > ${pname}.1
    installManPage ${pname}.1

    # Currently only bash completions are provided
    installShellCompletion --cmd git-team --bash <($out/bin/git-team completion bash)
  '';

  meta = with lib; {
    description = "Command line interface for managing and enhancing git commit messages with co-authors";
    homepage = "https://github.com/hekmekk/git-team";
    license = licenses.mit;
    maintainers = with maintainers; [ lockejan ];
  };
}
