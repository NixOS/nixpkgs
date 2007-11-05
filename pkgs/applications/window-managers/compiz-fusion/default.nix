args : with args;
rec
{
	bcop = import ./bcop args;
	libcompizconfig = import ./libcompizconfig (args // {inherit bcop;});
	configBackendGConf = import ./config-backend (args // {inherit bcop libcompizconfig;});
	compizConfigPython = import ./compizconfig-python (args // {inherit libcompizconfig 
		bcop pyrex configBackendGConf;});
	ccsm = import ./ccsm (args // {inherit libcompizconfig bcop compizConfigPython configBackendGConf;});
	pluginsMain = import ./main (args //{inherit bcop ;});
	compizManager = import ./compiz-manager (args // {inherit bcop ccsm;});
}
