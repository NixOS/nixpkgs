{
  version,
  src,
  pname,
  pnpm_9,
  nodejs,
  stdenv,
  meta,
  npm-hash,
}:
stdenv.mkDerivation {
  inherit version src meta;
  pname = "${pname}-webui";
  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = npm-hash;
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9.configHook
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
