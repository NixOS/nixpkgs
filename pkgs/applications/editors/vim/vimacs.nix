{ stdenv, config, vim_configurable, macvim, vimPlugins
, useMacvim ? stdenv.isDarwin && (config.vimacs.macvim or true)
, vimacsExtraArgs ? "" }:

stdenv.mkDerivation rec {
  pname = "vimacs";
  version = vimPackage.version;
  vimPackage = if useMacvim then macvim else vim_configurable;

  buildInputs = [ vimPackage vimPlugins.vimacs ];

  buildCommand = ''
    mkdir -p "$out"/bin
    cp "${vimPlugins.vimacs}"/share/vim-plugins/vimacs/bin/vim $out/bin/vimacs
    substituteInPlace "$out"/bin/vimacs \
      --replace '-vim}' '-@bin@/bin/vim}' \
      --replace '-gvim}' '-@bin@/bin/vim -g}' \
      --replace '--cmd "let g:VM_Enabled = 1"' \
                '--cmd "let g:VM_Enabled = 1" --cmd "set rtp^=@rtp@" ${vimacsExtraArgs}' \
      --replace @rtp@ ${vimPlugins.vimacs.rtp} \
      --replace @bin@ ${vimPackage}
    for prog in vm gvm gvimacs vmdiff vimacsdiff
    do
      ln -s "$out"/bin/vimacs $out/bin/$prog
    done
  '';

  meta = with stdenv.lib; {
    description = "Vim-Improved eMACS: Emacs emulation for Vim";
    homepage = "http://algorithm.com.au/code/vimacs";
    license = licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [ millerjason ];
  };
}
