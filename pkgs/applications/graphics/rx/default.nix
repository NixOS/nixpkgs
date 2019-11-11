{ stdenv, rustPlatform, fetchFromGitHub, makeWrapper
, cmake, pkgconfig
, xorg ? null
, vulkan-loader ? null }:

assert stdenv.isLinux -> xorg != null;
assert stdenv.isLinux -> vulkan-loader != null;

let
    graphicsBackend = if stdenv.isDarwin then "metal" else "vulkan";
in
  with stdenv.lib;
  rustPlatform.buildRustPackage rec {
    pname = "rx";
    version = "0.2.0";

    src = fetchFromGitHub {
      owner = "cloudhead";
      repo = pname;
      rev = "v${version}";
      sha256 = "0f6cw8zqr45bprj8ibhp89bb2a077g4zinfrdn943csdmh47qzcl";
    };

    cargoSha256 = "05bqsw0nw24xysq86qa3hx9b5ncf50wfxsgpy388yrs2dfnphwlx";

    nativeBuildInputs = [ cmake pkgconfig makeWrapper ];

    buildInputs = optionals stdenv.isLinux
    (with xorg; [
      # glfw-sys dependencies:
      libX11 libXrandr libXinerama libXcursor libXi libXext
    ]);

    cargoBuildFlags = [ "--features=${graphicsBackend}" ];

    # TODO: better to factor that into the rust platform
    checkPhase = ''
      runHook preCheck
      echo "Running cargo test"
      cargo test --features=${graphicsBackend}
      runHook postCheck
    '';

    postInstall = optional stdenv.isLinux ''
      mkdir -p $out/share/applications
      cp $src/rx.desktop $out/share/applications
      wrapProgram $out/bin/rx --prefix LD_LIBRARY_PATH : ${vulkan-loader}/lib
    '';

    meta = {
      description = "Modern and extensible pixel editor implemented in Rust";
      homepage = "https://cloudhead.io/rx/";
      license = licenses.gpl3;
      maintainers = with maintainers; [ minijackson ];
      platforms   = with platforms; (linux ++ darwin ++ windows);
      inherit version;
    };
  }
