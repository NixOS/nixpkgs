{
  qemu,
  fetchFromGitHub,
  meson,
  lzfse,
  lib,
  nettle,
}:

qemu.overrideAttrs (prevAttrs: {
  version = "0-unstable-2025-07-19";
  src = fetchFromGitHub {
    owner = "ChefKissInc";
    repo = "QEMUAppleSilicon";
    rev = "3e676a1e9565ca1ed6837e3ce107f430963d15af";
    hash = "sha256-mLGRlfyrcLgV/zbmeuJk+xhgPsFK3JMr7FxPOdfBrbE=";
    leaveDotGit = true;
    nativeBuildInputs = [
      meson
    ];
    postFetch = ''
      cd $out
      git reset

      # Only fetch required submodules
      git submodule update --init

      for prj in subprojects/*.wrap; do
        meson subprojects download "$(basename "$prj" .wrap)"
        rm -rf subprojects/$(basename "$prj" .wrap)/.git
      done

      find . -name .git -print0 | xargs -0 rm -rf
    '';
  };
  buildInputs = prevAttrs.buildInputs ++ [
    lzfse
    nettle
  ];
  configureFlags = prevAttrs.configureFlags ++ [ "--enable-nettle" ];
  meta = prevAttrs.meta // {
    description = "Apple Silicon devices emulated on QEMU, currently only iPhone 11";
    homepage = "https://github.com/ChefKissInc/QEMUAppleSilicon";
    license = with lib.licenses; [
      gpl2Plus
      lgpl21Only
    ];
    maintainers = with lib.maintainers; [ onny ];
  };
})
