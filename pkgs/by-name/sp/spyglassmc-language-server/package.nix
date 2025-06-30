{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  npm-lockfile-fix,
  nix-update-script,
  pkg-config,
  libsecret,
}:
buildNpmPackage (finalAttrs: {
  pname = "spyglassmc-language-server";
  version = "0.4.40";

  src = fetchFromGitHub {
    owner = "SpyglassMC";
    repo = "Spyglass";

    rev = "v2025.5.1+be914e";
    postFetch = ''
      ${lib.getExe npm-lockfile-fix} -r $out/package-lock.json
    '';
    hash = "sha256-chbaHffjZObBQ43qxyp3pUzso6PFIhRzfCB7oLyIXG0=";
  };

  # https://github.com/SpyglassMC/Spyglass/pull/1819
  patches = [ ./language-server-build-script.patch ];

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

  # TODO: does this work?
  passthru.updateScript = nix-update-script {
    #extraArgs = [];
  };

  meta = {
    homepage = "https://github.com/SpyglassMC/Spyglass";
    description = "Development tools for vanilla Minecraft: Java Edition data pack developers";
    maintainers = with lib.maintainers; [ axka ];
    license = lib.licenses.mit;
    mainProgram = "spyglassmc-language-server";
  };
})
