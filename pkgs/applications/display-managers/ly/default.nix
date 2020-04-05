{ stdenv, lib, fetchgit, runCommand, path, git, linux-pam, libxcb }:

stdenv.mkDerivation rec {
  pname = "ly";
  version = "0.5.0";

  src = let
    # locally modify `nix-prefetch-git` to recursively use upstream’s .github as .gitmodules…
    fetchgitMod = args: (fetchgit args).overrideAttrs (oldAttrs: {
      fetcher = runCommand "nix-prefetch-git-mod" {} ''
        cp ${path}/pkgs/build-support/fetchgit/nix-prefetch-git $out
        sed '/^init_submodules\(\)/a [ -e .gitmodules ] || cp .github .gitmodules || true' -i $out
        chmod 755 $out
      '';
    });
  in
    fetchgitMod {
      url = "https://github.com/cylgom/ly.git";
      rev = "v${version}";
      sha256 = "05fqpinln1kbxb7cby1ska3nfw9xf60ig2h2nj0xv167fsrqlhly";
    };

  buildInputs = [ linux-pam libxcb ];

  preConfigure = ''
    sed '/^FLAGS=/a FLAGS+= -Wno-error=unused-result' -i sub/termbox_next/makefile
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/ly $out/bin
  '';

  meta = with lib; {
    description = "TUI display manager";
    license = licenses.wtfpl;
    homepage = "https://github.com/cylgom/ly";
    platforms = platforms.linux;
    maintainers = [ maintainers.spacekookie ];
  };
}
