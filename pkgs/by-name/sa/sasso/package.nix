{
  lib,
  rustPlatform,
  fetchFromGitHub,
  runCommand,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "sasso";
  version = "0.15.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "momiji-rs";
    repo = "sasso";
    tag = "v${finalAttrs.version}";
    hash = "sha256-usQ8UxtnsknMdSwO2J9HKAxQafHziuJM3hbA3wbfJxg=";
  };

  cargoHash = "sha256-FcUPy8TAby4yeo3J6h4Nic/cidMMOzXa6kcv9VgLCl4=";

  # The sandbox has no network, which is what the test suite is already written
  # for: `tests/parity.rs` shells out to dart-sass only under `SASSO_PARITY=1`
  # and returns early otherwise. So the full suite runs here rather than only a
  # compile. The benchmark target is left out — timing anything inside a build
  # sandbox measures the builder, not the code.
  cargoTestFlags = [
    "--lib"
    "--bins"
    "--tests"
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };

    # `cargoTestFlags` above runs upstream's suite against the build tree. This
    # runs the INSTALLED binary, with the flag set a dart-sass build script
    # passes, and pins the bytes it emits — including the CSS Color 4
    # serialization that is the reason to reach for this compiler rather than
    # an older one, which no exit code would catch drifting.
    tests.compiles-a-stylesheet =
      runCommand "sasso-compiles-a-stylesheet"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          cat > in.scss <<'SCSS'
          @use "sass:color";

          $brand: #2a7ae2;
          $gap: 4px;

          .button {
            color: $brand;
            padding: $gap * 2;

            &:hover {
              color: color.adjust($brand, $lightness: -10%);
            }

            .icon + .label {
              margin-inline-start: $gap;
            }
          }
          SCSS

          sasso --no-error-css --stop-on-error --no-color --quiet --quiet-deps \
            --style=compressed --no-source-map in.scss:out.css

          cat > expected.css <<'CSS'
          .button{color:#2a7ae2;padding:8px}.button:hover{color:rgb(10.1976989143%,38.3292821261%,74.9003403014%)}.button .icon+.label{margin-inline-start:4px}
          CSS

          if ! diff -u expected.css out.css; then
            echo "sasso's output changed; see the diff above" >&2
            exit 1
          fi
          touch $out
        '';
  };

  meta = {
    description = "Pure-Rust SCSS to CSS compiler (a dart-sass alternative)";
    longDescription = ''
      sasso compiles SCSS and the indented Sass syntax to CSS with no runtime
      dependencies: no libsass, no Dart VM, no native add-ons. It passes 98.9%
      of the attempted sass-spec suite byte-for-byte against dart-sass, and
      ships as a CLI with a dart-sass-compatible command line, a Rust library,
      a C ABI, and a WebAssembly build for JavaScript build tools.
    '';
    homepage = "https://github.com/momiji-rs/sasso";
    changelog = "https://github.com/momiji-rs/sasso/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    mainProgram = "sasso";
    maintainers = with lib.maintainers; [ linyiru ];
    platforms = lib.platforms.unix;
  };
})
