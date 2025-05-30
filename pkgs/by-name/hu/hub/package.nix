{
  lib,
  buildGoModule,
  fetchpatch,
  fetchFromGitHub,
  git,
  groff,
  installShellFiles,
  makeWrapper,
  unixtools,
  nixosTests,
}:

buildGoModule rec {
  pname = "hub";
  version = "unstable-2022-12-01";

  src = fetchFromGitHub {
    owner = "github";
    repo = "hub";
    rev = "38bcd4ae469e5f53f01901340b715c7658ab417a";
    hash = "sha256-V2GvwKj0m2UXxE42G23OHXyAsTrVRNw1p5CAaJxGYog=";
  };

  patches = [
    # Fix `fish` completions
    # https://github.com/github/hub/pull/3036
    (fetchpatch {
      url = "https://github.com/github/hub/commit/439b7699e79471fc789929bcdea2f30bd719963e.patch";
      hash = "sha256-pR/OkGa2ICR4n1pLNx8E2UTtLeDwFtXxeeTB94KFjC4=";
    })
    # Fix `bash` completions
    # https://github.com/github/hub/pull/2948
    (fetchpatch {
      url = "https://github.com/github/hub/commit/64b291006f208fc7db1d5be96ff7db5535f1d853.patch";
      hash = "sha256-jGFFIvSKEIpTQY0Wz63cqciUk25MzPHv5Z1ox8l7wmo=";
    })
  ];

  postPatch = ''
    patchShebangs script/
    sed -i 's/^var Version = "[^"]\+"$/var Version = "${version}"/' version/version.go
  '';

  vendorHash = "sha256-wQH8V9jRgh45JGs4IfYS1GtmCIYdo93JG1UjJ0BGxXk=";

  # Only needed to build the man-pages
  excludedPackages = [ "github.com/github/hub/md2roff-bin" ];

  nativeBuildInputs = [
    groff
    installShellFiles
    makeWrapper
    unixtools.col
  ];

  postInstall = ''
    installShellCompletion --cmd hub \
      --bash etc/hub.bash_completion.sh \
      --fish etc/hub.fish_completion \
      --zsh etc/hub.zsh_completion

    LC_ALL=C.UTF8 make man-pages
    installManPage share/man/man[1-9]/*.[1-9]

    wrapProgram $out/bin/hub \
      --suffix PATH : ${lib.makeBinPath [ git ]}
  '';

  nativeCheckInputs = [
    git
  ];

  passthru.tests = { inherit (nixosTests) hub; };

  meta = with lib; {
    description = "Command-line wrapper for git that makes you better at GitHub";
    homepage = "https://hub.github.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ globin ];
  };
}
