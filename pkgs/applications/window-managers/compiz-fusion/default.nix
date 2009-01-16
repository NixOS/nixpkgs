args : with args;
rec
{
        selectVersion = dir: import (dir + "/${args.version}.nix");
	bcop = selectVersion ./bcop args;
	libcompizconfig = selectVersion ./libcompizconfig (args // {inherit bcop;});
	configBackendGConf = selectVersion ./config-backend (args // {inherit bcop libcompizconfig;});
	compizConfigPython = selectVersion ./compizconfig-python (args // {inherit libcompizconfig 
		bcop pyrex configBackendGConf;});
	ccsm = selectVersion ./ccsm (args // {inherit libcompizconfig bcop compizConfigPython configBackendGConf;});
	pluginsMain = selectVersion ./main (args //{inherit bcop ;});
	pluginsExtra = selectVersion ./extra (args //{inherit bcop pluginsMain;});
	compizManager = (import ./compiz-manager/0.6.0.nix) (args // {inherit bcop ccsm;});
	ccsmSimple = selectVersion ./ccsm-simple (args // {inherit libcompizconfig bcop compizConfigPython configBackendGConf;});
}
