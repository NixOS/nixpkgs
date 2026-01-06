{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "dumppif";
  version = "1.0.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "viraptor";
    repo = "dumppif";
    tag = finalAttrs.version;
    hash = "sha256-uCWRH40PvLoDTs2RxGc33orOHOljVVXJNh3iODcbvIc=";
  };

  cargoHash = "sha256-zW9sKyzM9CyWsZ0e3he9lttqwtxGimzIyq0e67+88Bw=";

  meta = {
    mainProgram = "xcodebuild";
    description = "Minimal implementation of xcodebuild which only provides -dumpPIF";
    homepage = "https://github.com/viraptor/dumppif";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ viraptor ];
    platforms = lib.platforms.unix;
  };
})
