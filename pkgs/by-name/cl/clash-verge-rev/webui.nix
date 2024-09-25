{
  version,
  src,
  pname,
  pnpm,
  nodejs,
  stdenv,
  meta,
}:
stdenv.mkDerivation {
  inherit version src meta;
  pname = "${pname}-webui";
  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src;
    hash = "sha256-DYsx1X1yXYEPFuMlvZtbJdefcCR8/wSUidFwsMy8oLk=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm.configHook
  ];

  postPatch = ''
    chmod -R +644 -- ./src/components/setting/mods/clash-core-viewer.tsx
    chmod -R +644 -- ./src/components/setting/mods
    sed -i -e '/Mihomo Alpha/d' ./src/components/setting/mods/clash-core-viewer.tsx
  '';

  buildPhase = ''
    runHook preBuild

    node --max_old_space_size=1024000 ./node_modules/vite/bin/vite.js build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist $out

    runHook postInstall
  '';
}
