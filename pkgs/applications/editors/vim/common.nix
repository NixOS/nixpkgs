{ lib, fetchFromGitHub, fetchpatch, applyPatches }:
rec {
  version = "9.0.0609";

  src = applyPatches {
    src = fetchFromGitHub {
      owner = "vim";
      repo = "vim";
      rev = "v${version}";
      hash = "sha256-UBj3pXY6rdekKnCX/V/4o8LLBMZkNs1U4Z4KuvisIYQ=";
    };
    patches = [
      (fetchpatch {
        url = "https://github.com/vim/vim/commit/23a971da506249fc8388f06cd5c011b83406ac5c.patch";
        hash = "sha256-G9WiIU6gyIsfL6KL4qku3sgxtp0aitol60VJSUmSKdo=";
      })
    ];
  };

  enableParallelBuilding = true;

  hardeningDisable = [ "fortify" ];

  postPatch =
    # Use man from $PATH; escape sequences are still problematic.
    ''
      substituteInPlace runtime/ftplugin/man.vim \
        --replace "/usr/bin/man " "man "
    '';

  meta = with lib; {
    description = "The most popular clone of the VI editor";
    homepage    = "http://www.vim.org";
    license     = licenses.vim;
    maintainers = with maintainers; [ das_j equirosa ];
    platforms   = platforms.unix;
  };
}
