{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  unstableGitUpdater,
}:
stdenvNoCC.mkDerivation {
  pname = "oh-my-rime";
  version = "0-unstable-2026-11-14";

  src = fetchFromGitHub {
    owner = "Mintimate";
    repo = "oh-my-rime";
    rev = "0cf3d63c61d07a84834c031bad4ef8ac39b322d0";
    hash = "sha256-vi9JMdSN3vdkHwVowTsJ1EEvYcaH92cb/VM47m8kRfY=";
  };

  installPhase = # bash
    ''
      runHook preInstall

      rm -rf README*.md .git* .ide plum preview .cnb.yml demo.webp LICENSE

      mv default.yaml oh_my_rime_suggested_default.yaml

      mkdir -p $out/share
      cp -r . $out/share/rime-data

      runHook postInstall
    '';

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  strictDeps = true;
  __structuredAttrs = true;

  meta = {
    description = "Rime configuration template with multiple Chinese input schemas";
    longDescription = ''
      Oh My Rime, also known as Mint Input Method, is a ready-to-use
      configuration template for Rime. It includes full and double pinyin,
      Terra Pinyin, and Wubi input schemas, along with dictionaries, Lua
      scripts, and themes.

      The upstream `default.yaml` is included as
      `oh_my_rime_suggested_default.yaml`. To enable it, add the following to
      your `default.custom.yaml`:

      ```yaml
      patch:
        __include: oh_my_rime_suggested_default:/
      ```
    '';
    homepage = "https://github.com/Mintimate/oh-my-rime";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ulic-youthlic ];
  };
}
