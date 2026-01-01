{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
<<<<<<< HEAD
  nodejs_20,
}:

buildNpmPackage (finalAttrs: {
  pname = "scanservjs";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "sbs20";
    repo = "scanservjs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qCJyQO/hSDF4NOupV7sepwvpNyjSElnqT71LJuIKe+A=";
  };

  npmDepsHash = "sha256-HIWT09G8gqSFt9CIjsjJaDRnj2GO0G6JOGeI0p4/1vw=";

  # Build fails on node 22, presumably because of esm.
  # https://github.com/NixOS/nixpkgs/issues/371649
  nodejs = nodejs_20;

  postInstall = ''
    mkdir $out/bin
    makeWrapper ${lib.getExe finalAttrs.nodejs} $out/bin/scanservjs \
      --set NODE_ENV production \
      --add-flags "'$out/lib/node_modules/scanservjs/app-server/src/server.js'"
=======
  fetchNpmDeps,
  nodejs_20,
  replaceVars,
}:

let
  # Build fails on node 22, presumably because of esm.
  # https://github.com/NixOS/nixpkgs/issues/371649
  nodejs = nodejs_20;
  version = "2.27.1";
  src = fetchFromGitHub {
    owner = "sbs20";
    repo = "scanservjs";
    # rev = "v${version}";
    # 2.27.1 doesn't have a tag
    rev = "b15adc6f97fb152fd9819371bb1a9b8118baf55b";
    hash = "sha256-ne9fEF/eurWPXzmJQzBn5jiy+JgxMWiCXsOdmu2fj6E=";
  };

  depsHashes = {
    server = "sha256-M8t+TrE+ntZaI9X7hEel94bz34DPtW32n0KKMSoCfIs=";
    client = "sha256-C31WBYE8ba0t4mfKFAuYWrCZtSdN7tQIYmCflDRKuBM=";
  };

  serverDepsForClient = fetchNpmDeps {
    inherit src nodejs;
    sourceRoot = "${src.name}/packages/server";
    name = "scanservjs";
    hash = depsHashes.server or lib.fakeHash;
  };

  # static client files
  client = buildNpmPackage {
    pname = "scanservjs-client";
    inherit version src nodejs;

    sourceRoot = "${src.name}/packages/client";
    npmDepsHash = depsHashes.client or lib.fakeHash;

    preBuild = ''
      cd ../server
      chmod +w package-lock.json . /build/source/
      npmDeps=${serverDepsForClient} npmConfigHook
      cd ../client
    '';

    env.NODE_OPTIONS = "--openssl-legacy-provider";

    dontNpmInstall = true;
    installPhase = ''
      mv /build/source/dist/client $out
    '';
  };

in
buildNpmPackage {
  pname = "scanservjs";
  inherit version src nodejs;

  sourceRoot = "${src.name}/packages/server";
  npmDepsHash = depsHashes.server or lib.fakeHash;

  # can't use "patches" since they change the server deps' hash for building the client
  # (I don't want to maintain one more hash)
  preBuild = ''
    chmod +w /build/source
    patch -p3 <${
      replaceVars ./decouple-from-source-tree.patch {
        inherit client;
      }
    }
    substituteInPlace src/api.js --replace 'NIX_OUT_PLACEHOLDER' "$out"
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper ${lib.getExe nodejs} $out/bin/scanservjs \
      --set NODE_ENV production \
      --add-flags "'$out/lib/node_modules/scanservjs-api/src/server.js'"
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  '';

  meta = {
    description = "SANE scanner nodejs web ui";
    longDescription = "scanservjs is a simple web-based UI for SANE which allows you to share a scanner on a network without the need for drivers or complicated installation.";
    homepage = "https://github.com/sbs20/scanservjs";
    license = lib.licenses.gpl2Only;
    mainProgram = "scanservjs";
    maintainers = with lib.maintainers; [ chayleaf ];
    platforms = lib.platforms.linux;
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
