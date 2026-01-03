{
  lib,
  stdenv,
  writeText,
  fetchFromGitHub,
  cmake,
  windows,
  nix-update-script,
}:
let
  # Requires an /etc/os-release file, so we override it with this.
  osRelease = writeText "os-release" ''ID=NixOS'';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "openapv";
  version = "0.2.0.4";

  src = fetchFromGitHub {
    owner = "AcademySoftwareFoundation";
    repo = "openapv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-IkzZnf2/JZJIwg9g/6SvWTAcUkAQ/C36xXC+t44VejU=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "/etc/os-release" "${osRelease}"
  '';

  nativeBuildInputs = [ cmake ];

  # openapv uses CMake Threads and links with -lpthread on MinGW.
  # MSYS2 provides a working mingw-w64-openapv package; in nixpkgs the pthread
  # provider is `windows.pthreads` (winpthreads).
  buildInputs = lib.optionals stdenv.hostPlatform.isMinGW [ windows.pthreads ];
  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isMinGW "-lpthread";

  postInstall = ''
    # Upstream installs libraries under $out/lib/oapv[/import], but consumers
    # (including FFmpeg's configure checks) expect -L$out/lib -loapv to work.
    if [ -d "$out/lib/oapv" ]; then
      if [ -e "$out/lib/oapv/liboapv.a" ]; then
        mv "$out/lib/oapv/liboapv.a" "$out/lib/"
      fi
      if [ -d "$out/lib/oapv/import" ]; then
        shopt -s nullglob
        for f in "$out/lib/oapv/import/"liboapv*.dll.a; do
          mv "$f" "$out/lib/"
        done
        shopt -u nullglob
      fi
    fi
  '';

  postFixup = ''
    # Fix broken paths produced by upstream oapv.pc generation (double prefix and
    # include dir pointing at .../include/oapv). Keep it minimal and correct.
    cat > "$out/lib/pkgconfig/oapv.pc" <<'EOF'
prefix=@prefix@
exec_prefix=''${prefix}
libdir=''${prefix}/lib
includedir=''${prefix}/include

Name: oapv
Description: Advanced Professional Video Codec
Version: @version@
Libs: -L''${libdir} -loapv
Libs.private: -lm@pthread@
Cflags: -I''${includedir}
EOF

    substituteInPlace "$out/lib/pkgconfig/oapv.pc" \
      --replace-fail "@prefix@" "$out" \
      --replace-fail "@version@" "${finalAttrs.version}" \
      --replace-fail "@pthread@" "${lib.optionalString stdenv.hostPlatform.isMinGW " -lpthread"}"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/AcademySoftwareFoundation/openapv/releases/tag/v${finalAttrs.version}";
    description = "Reference implementation of the APV codec";
    homepage = "https://github.com/AcademySoftwareFoundation/openapv";
    license = [ lib.licenses.bsd3 ];
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
})
