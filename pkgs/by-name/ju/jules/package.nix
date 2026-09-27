{
  lib,
  buildNpmPackage,
  fetchzip,
  fetchurl,
  autoPatchelfHook,
  stdenv,
}:

let
  version = "0.1.42";

  # Platform-specific binary sources
  binarySources = {
    x86_64-linux = {
      platform = "linux";
      arch = "amd64";
      hash = "sha256-c869LI+Jubsk703MuM15Q8y2npmzfeJnwvV5Mjen0QM=";
    };
    aarch64-linux = {
      platform = "linux";
      arch = "arm64";
      hash = "sha256-cB0Eo25xUC3G6p/Jc0U7IsoIVQatLLqmwLZzkX7N+/w=";
    };
    x86_64-darwin = {
      platform = "darwin";
      arch = "amd64";
      hash = "sha256-CYqHk6+o1pMJmM9rQvr4+/RKjTZS7jBcAzWltybhFnQ=";
    };
    aarch64-darwin = {
      platform = "darwin";
      arch = "arm64";
      hash = "sha256-iedh0tQC3dLObgY0Xf5HPfwCSxqYp2OZCQ9xPuKuklQ=";
    };
  };

  binarySource =
    binarySources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  julesBinary = fetchurl {
    url = "https://storage.googleapis.com/jules-cli/v${version}/jules_external_v${version}_${binarySource.platform}_${binarySource.arch}.tar.gz";
    inherit (binarySource) hash;
  };
in
buildNpmPackage (finalAttrs: {
  pname = "jules";
  inherit version;

  src = fetchzip {
    url = "https://registry.npmjs.org/@google/jules/-/jules-${version}.tgz";
    hash = "sha256-EPOcnUChxdWtDvXqHPd2k9hkeNOA0SB9SH7yP+mMLoQ=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-CIYydNcEavCbyupQAUGkT3AWv/2ih/IIrQccGmEHW+k=";

  dontNpmBuild = true;

  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];

  postInstall = ''
    # Extract and install the pre-built binary
    tar -xzf ${julesBinary} -C $out/lib/node_modules/@google/jules
    chmod +x $out/lib/node_modules/@google/jules/jules

    # Link the binary directly instead of using the node wrapper
    rm $out/bin/jules
    ln -s $out/lib/node_modules/@google/jules/jules $out/bin/jules
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Jules, the asynchronous coding agent from Google, in the terminal";
    homepage = "https://jules.google";
    downloadPage = "https://www.npmjs.com/package/@google/jules";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      deftdawg
    ];
    mainProgram = "jules";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
