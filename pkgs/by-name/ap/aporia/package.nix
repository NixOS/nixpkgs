{
  lib,
  buildGoModule,
  fetchFromGitHub,
  fetchpatch2,
  linux-pam,
  bash,
  util-linux,
  makeWrapper,
  xorg,
}:

buildGoModule (finalAttrs: {
  pname = "aporia";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Lunarmagpie";
    repo = "aporia";
    tag = finalAttrs.version;
    hash = "sha256-n6xqcn1ZZNlV5hthZQSg5yJCOFaeVuuLFo/U+E0TihA=";
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

  patches = [
    # fix build error
    (fetchpatch2 {
      url = "https://github.com/zunda-arrow/aporia/commit/76444c7ec6db0ed774e9b70bf30580d06b4c179b.patch?full_index=1";
      hash = "sha256-J827TDodF26PBpNog7/ztfsCY/nUJMbHWU7tPrD+IdY=";
    })
  ];

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ linux-pam ];

  installPhase = ''
    mkdir -p $out/bin

    install -Dm 755 $GOPATH/bin/aporia $out/bin/aporia
    install -Dm 755 extra/xsetup.sh $out/scripts/xsetup.sh
    install -Dm 755 extra/startx.sh $out/scripts/startx.sh
    wrapProgram $out/scripts/startx.sh \
      --prefix PATH : ${lib.makeBinPath [ xorg.xinit ]}
  '';

  doCheck = false;

  meta = {
    description = "Login manager that displays ascii art";
    license = lib.licenses.wtfpl;
    homepage = "https://github.com/Lunarmagpie/aporia";
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
