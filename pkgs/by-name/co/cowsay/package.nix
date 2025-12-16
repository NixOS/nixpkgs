{
  lib,
  fetchFromGitHub,
  makeWrapper,
  nix-update-script,
  perl,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cowsay";
  version = "3.8.4";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "cowsay-org";
    repo = "cowsay";
    rev = "v${finalAttrs.version}";
    hash = "sha256-m3Rndw0rnTBLhs15KqokzIOWuYl6aoPqEu2MHWpXRCs=";
  };

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ perl ];

  makeFlags = [ "prefix=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/cowsay \
      --suffix COWPATH : $out/share/cowsay/cows

    # Replace the cowthink symlink with a Perl wrapper that sets $0 correctly
    # This is necessary because exec -a doesn't work for Perl scripts
    rm $out/bin/cowthink
    cat > $out/bin/cowthink << EOF
    #!/usr/bin/env perl
    \$0 = "cowthink";
    \$ENV{COWPATH} = "\$ENV{COWPATH}" . (\$ENV{COWPATH} ? ":" : "") . "$out/share/cowsay/cows";
    do "$out/bin/.cowsay-wrapped";
    EOF
    chmod +x $out/bin/cowthink
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "cowsay --version";
    };
  };

  meta = {
    description = "Program which generates ASCII pictures of a cow with a message";
    homepage = "https://cowsay.diamonds";
    changelog = "https://github.com/cowsay-org/cowsay/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      rob
      anthonyroussel
    ];
    mainProgram = "cowsay";
  };
})
