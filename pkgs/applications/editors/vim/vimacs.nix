{ lib, stdenv, config, vim-full, macvim, vimPlugins
, useMacvim ? stdenv.isDarwin && (config.vimacs.macvim or true)
, vimacsExtraArgs ? "" }:

stdenv.mkDerivation rec {
  pname = "vimacs";
  version = lib.getVersion vimPackage;
  vimPackage = if useMacvim then macvim else vim-full;

  buildInputs = [ vimPackage vimPlugins.vimacs ];

  buildCommand = ''
    mkdir -p "$out"/bin
    cp "${vimPlugins.vimacs}"/bin/vim $out/bin/vimacs
    substituteInPlace "$out"/bin/vimacs \
      --replace '-vim}' '-@bin@/bin/vim}' \
      --replace '-gvim}' '-@bin@/bin/vim -g}' \
      --replace '--cmd "let g:VM_Enabled = 1"' \
                '--cmd "let g:VM_Enabled = 1" --cmd "set rtp^=@rtp@" ${vimacsExtraArgs}' \
      --replace @rtp@ ${vimPlugins.vimacs} \
      --replace @bin@ ${vimPackage}
    for prog in vm gvm gvimacs vmdiff vimacsdiff
    do
      ln -s "$out"/bin/vimacs $out/bin/$prog
    done
  '';

  meta = with lib; {
    description = "Vim-Improved eMACS: Emacs emulation for Vim";
    homepage = "http://algorithm.com.au/code/vimacs";
    license = licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ millerjason ];
  };
}
