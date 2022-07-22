{ lib
, buildGoModule
, fetchpatch
, fetchFromGitHub
, git
, groff
, installShellFiles
, makeWrapper
, unixtools
, nixosTests
}:

buildGoModule rec {
  pname = "hub";
  version = "unstable-2022-04-04";

  src = fetchFromGitHub {
    owner = "github";
    repo = pname;
    rev = "363513a0f822a8bde5b620e5de183702280d4ace";
    sha256 = "sha256-jipZHmGtPTsztTeVZofaMReU4AEU9k6mdw9YC4KKB1Q=";
  };

  postPatch = ''
    patchShebangs script/
  '';

  vendorSha256 = "sha256-wQH8V9jRgh45JGs4IfYS1GtmCIYdo93JG1UjJ0BGxXk=";

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

  checkInputs = [
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
