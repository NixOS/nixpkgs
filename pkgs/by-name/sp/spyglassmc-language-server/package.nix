{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  npm-lockfile-fix,
  pkg-config,
  libsecret,
}:
buildNpmPackage (finalAttrs: {
  pname = "spyglassmc-language-server";
  version = "0.4.43"; # `jq -r '."language-server".released.version' .packages.json`

  # TODO: is it an issue that result/lib/node_modules/@spyglassmc/language-server/package.json contains 0.1.0-PLACEHOLDER ?

  src = fetchFromGitHub {
    owner = "SpyglassMC";
    repo = "Spyglass";

    rev = "v2025.7.14+95eceb"; # the Git tags are atomically added with new versions of packages
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} -r $out/package-lock.json
    '';
    hash = "sha256-KK1Wzbq4yB5id2xUB7GvV/t7WT5AaGfWf1t1lRbybhw=";
  };

  npmDepsHash = "sha256-0xjjRqCjaLL6YAgNE5X5wDCL7C+E/ssZ4qFZ+Ey/Wmg=";

  npmWorkspace = "packages/language-server";

  # TODO: make this work!
  # 408 MiB -> 1.7 MiB ???
  # outside Nix 408 MiB -> 41 MiB after prune
  #npmInstallFlags = [ "--workspace=${finalAttrs.npmWorkspace}" ];

  nativeBuildInputs = [
    (python3.withPackages (ps: [ ps.setuptools ])) # Used by node-gyp

    pkg-config
  ];
  buildInputs = [
    libsecret # Used by keytar
  ];

  meta = {
    homepage = "https://github.com/SpyglassMC/Spyglass";
    description = "Development tools for vanilla Minecraft: Java Edition data pack developers";
    maintainers = with lib.maintainers; [ axka ];
    license = lib.licenses.mit;
    mainProgram = "spyglassmc-language-server";
  };
})
