{
  lib,
  fetchFromGitHub,
  stdenv,
  nix-update-script,

  ncurses,
  gnupg,
}:

stdenv.mkDerivation (finalAttrs: {
  # mdp renamed to gpg-mdp because there is a mdp package already.
  pname = "gpg-mdp";
  version = "0.7.5";

  meta = {
    homepage = "https://tamentis.com/projects/mdp/";
    changelog = "https://github.com/tamentis/mdp/releases/tag/v${finalAttrs.version}";
    license = [ lib.licenses.isc ];
    description = "Manage your passwords with GnuPG and a text editor";
  };

  src = fetchFromGitHub {
    owner = "tamentis";
    repo = "mdp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Y92y70XkUbB+lhWAzEkCB/cvfUPPKIfu0yrlCS2pKn0=";
  };

  buildInputs = [ ncurses ];

  prePatch = ''
    substituteInPlace ./configure \
      --replace-fail "alias echo=/bin/echo" "" \
      --replace-fail "main()" "int main()"

    substituteInPlace ./src/config.c \
      --replace-fail "/usr/bin/gpg" "${lib.getExe gnupg}" \
      --replace-fail "/usr/bin/vi" "vi"

    substituteInPlace ./mdp.1 \
      --replace-fail "/usr/bin/gpg" "${lib.getExe gnupg}"
  '';

  # we add symlinks to the binary and man page with the name 'gpg-mdp', in case
  # the completely unrelated program also named 'mdp' is already installed.
  postFixup = ''
    ln -s $out/bin/mdp $out/bin/gpg-mdp
    ln -s $out/share/man/man1/mdp.1.gz $out/share/man/man1/gpg-mdp.1.gz
  '';

  passthru.updateScript = nix-update-script { };
})
