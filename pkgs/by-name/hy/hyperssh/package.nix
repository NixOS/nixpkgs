{
  buildNpmPackage,
  fetchFromGitHub,
  fetchurl,
  lib,
  patchelfUnstable,
}:

buildNpmPackage {
  pname = "hyperssh";
  version = "5.0.3";

  npmDepsHash = "sha256-nT++cvYbY+zsebIaMZ0hUhK9pAX17GTbQyuixdCjojM=";

  makeCacheWritable = true;

  dontNpmBuild = true;

  src = fetchFromGitHub {
    owner = "mafintosh";
    repo = "hyperssh";
    rev = "v5.0.3";
    hash = "sha256-vjPSNcQRsqu0ee0hownEE9y8dFf9dqaL7alGRc9WjcI=2";
  };

  patches = [
    # TODO: remove after this is merged: https://github.com/mafintosh/hyperssh/pull/16
    (fetchurl {
      url = "https://github.com/mafintosh/hyperssh/commit/ad1d0e06a133e71c9df9f59dd5f805c49f46ec70.patch";
      hash = "sha256-fUjgHHbZHgqokNg2fVVZCjoDA3LqSJiFzBwgA8Tt1m4=";
    })
  ];

  nativeBuildInputs = [
    patchelfUnstable # --clear-execstack is only available on 0.18
  ];

  postInstall = ''
    # glibc 2.41+ refuses to make the stack executable if it isn't executable,
    # but a library loaded via `dlopen()` mandates it.
    # According to https://github.com/holepunchto/sodium-native/issues/214
    # this isn't necessary in this case.
    while IFS= read -r -d ''' file; do
      # Skip PEs with the same name
      if patchelf --print-rpath "$file" &>/dev/null; then
        patchelf "$file" --clear-execstack
      fi
    done < <(find $out/lib/node_modules -name 'sodium-native.node' -print0)
  '';

  meta = {
    description = "Run SSH over hyperswarm";
    homepage = "https://github.com/mafintosh/hyperssh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ davhau ];
    mainProgram = "hyperssh";
    platforms = lib.platforms.all;
  };
}
