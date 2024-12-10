{
  coreutils,
  fetchFromGitHub,
  fontconfig,
  gawk,
  getopt,
  i3lock-color,
  imagemagick,
  installShellFiles,
  lib,
  makeWrapper,
  scrot,
  stdenv,

  screenshotCommand ? "",
}:

stdenv.mkDerivation {
  pname = "i3lock-fancy";
  version = "unstable-2023-04-28";

  src = fetchFromGitHub {
    owner = "meskarune";
    repo = "i3lock-fancy";
    rev = "55f5c30071403faf5ae4363a54b6d1f63876d5ce";
    hash = "sha256-ISymKlxLE4/ChDiyjnavFx4T5hEVI62cCxYLWrWiHrg=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  postPatch =
    ''
      sed -i i3lock-fancy \
        -e 's|icon="/usr/share/i3lock-fancy/icons/lockdark.png"|icon="'$out'/share/i3lock-fancy/icons/lockdark.png"|' \
        -e 's|icon="/usr/share/i3lock-fancy/icons/lock.png"|icon="'$out'/share/i3lock-fancy/icons/lock.png"|'
      rm Makefile
    ''
    + lib.optionalString (screenshotCommand != "") ''
      sed -i i3lock-fancy \
        -e "s|shot=(import -silent -window root)|shot=(${screenshotCommand})|";
    '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/i3lock-fancy/icons
    cp i3lock-fancy $out/bin/i3lock-fancy
    ln -s $out/bin/i3lock-fancy $out/bin/i3lock
    cp icons/lock*.png $out/share/i3lock-fancy/icons
    installManPage doc/i3lock-fancy.1

    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/i3lock-fancy \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          fontconfig
          gawk
          getopt
          i3lock-color
          imagemagick
          scrot
        ]
      }
  '';

  meta = with lib; {
    description = "i3lock is a bash script that takes a screenshot of the desktop, blurs the background and adds a lock icon and text";
    homepage = "https://github.com/meskarune/i3lock-fancy";
    maintainers = [ maintainers.reedrw ];
    mainProgram = "i3lock-fancy";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
