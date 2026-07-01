{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "libtogl";
  version = "0.5.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "smorin";
    repo = "toggle";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JUs98p2FDWG4/0mh8LnX0UhPOKIuaBFBixqdnhjxGyM=";
  };

  cargoHash = "sha256-LO8dAvm9OegESxobknPBF5FrSCcQ29qNymPATWJ14z4=";

  # Build only the FFI crate (produces the static + shared C library).
  cargoBuildFlags = [
    "-p"
    "togl-ffi"
  ];

  # The crate's C smoke test shells out to a C compiler and a nested cargo
  # build, which is impractical in the sandbox; the FFI surface is covered by
  # the crate's Rust unit tests upstream.
  doCheck = false;

  outputs = [
    "out"
    "dev"
  ];

  # cargoInstallHook installs the built `libtogl.{a,so/dylib}` into $out/lib.
  # Keep the shared library in $out (runtime); move the static library to $dev
  # alongside the header and pkg-config file (development closure).
  postInstall = ''
    install -Dm444 "$out/lib/libtogl.a" -t "$dev/lib"
    rm "$out/lib/libtogl.a"

    # Install the committed header and pkg-config template from the fetched
    # source, not the build dir — independent of whether build.rs regenerated
    # the header during compilation.
    install -Dm444 ${finalAttrs.src}/crates/togl-ffi/include/togl.h -t "$dev/include"

    mkdir -p "$dev/lib/pkgconfig"
    substitute ${finalAttrs.src}/crates/togl-ffi/togl.pc.in "$dev/lib/pkgconfig/togl.pc" \
      --subst-var-by prefix "$dev" \
      --subst-var-by version "${finalAttrs.version}"
    # The header lives in $dev; the shared library lives in $out — point libdir there.
    substituteInPlace "$dev/lib/pkgconfig/togl.pc" \
      --replace-fail 'exec_prefix=''${prefix}' "exec_prefix=$out"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ABI-stable C library (libtogl) for toggling code comments across languages";
    homepage = "https://github.com/smorin/toggle";
    changelog = "https://github.com/smorin/toggle/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ smorin ];
    pkgConfigModules = [ "togl" ];
    platforms = lib.platforms.unix;
  };
})
