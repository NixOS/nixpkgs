{
  lib,
  buildGoModule,
  fetchFromGitHub,
  linux-pam,
  bash,
  util-linux,
  makeWrapper,
  xorg
}:

buildGoModule {
  pname = "aporia";
  version = "0-unstable-2024-06-01";

  src = fetchFromGitHub {
    owner = "Lunarmagpie";
    repo = "aporia";
    rev = "2ee1bf8f98b48fc6ee011cfcb372ad0ea530fa19";
    hash = "sha256-TM5zGIUflpv3yjcAOan8T+m1iTSj9p8pUViEHcZHBL4=";
  };

  vendorHash = "sha256-OG14/f707RRNZqDtGPPnphP9kXP4abGaBfNvlPsC0pk=";

  prePatch = ''
    patchShebangs .;

    substituteInPlace constants/constants.go \
      --replace-fail "/etc/aporia/.scripts" "${placeholder "out"}/scripts" \
      --replace-fail "/etc/pam.d" "${placeholder "out"}/etc/pam.d" \
      --replace-fail "/bin/bash" "${lib.getExe bash}"

    substituteInPlace extra/startx.sh \
      --replace-fail "/usr/bin/mcookie" "${util-linux}/bin/mcookie" \
      --replace-fail "/usr/bin/X" "${xorg.xorgserver}/bin/X"
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ linux-pam ];

  installPhase = ''
    mkdir -p $out/bin

    install -Dm 755 $GOPATH/bin/aporia $out/bin/aporia
    install -Dm 755 extra/xsetup.sh $out/scripts/xsetup.sh
    install -Dm 755 extra/startx.sh $out/scripts/startx.sh
    wrapProgram $out/scripts/startx.sh \
      --prefix PATH : ${lib.makeBinPath [xorg.xinit]}
  '';

  doCheck = false;

  meta = with lib; {
    description = "A login manager that displays ascii art";
    license = licenses.wtfpl;
    homepage = "https://github.com/Lunarmagpie/aporia";
    maintainers = with maintainers; [ sigmanificient ];
  };
}
