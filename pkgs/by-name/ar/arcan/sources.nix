{
  fetchFromGitHub,
}:

{
  letoram-arcan = {
    pname = "arcan";
    version = "0.6.2.1-unstable-2023-11-18";

    src = fetchFromGitHub {
      owner = "letoram";
      repo = "arcan";
      rev = "0950ee236f96a555729498d0fdf91c16901037f5";
      hash = "sha256-TxadRlidy4KRaQ4HunPO6ISJqm6JwnMRM8y6dX6vqJ4=";
    };
  };

  letoram-openal = {
    pname = "letoram-openal";
    version = "0.6.2";

    src = fetchFromGitHub {
      owner = "letoram";
      repo = "openal";
      rev = "81e1b364339b6aa2b183f39fc16c55eb5857e97a";
      hash = "sha256-X3C3TDZPiOhdZdpApC4h4KeBiWFMxkFsmE3gQ1Rz420=";
    };
  };

  libuvc = {
    pname = "libuvc";
    version = "0.0.7";

    src = fetchFromGitHub {
      owner = "libuvc";
      repo = "libuvc";
      rev = "68d07a00e11d1944e27b7295ee69673239c00b4b";
      hash = "sha256-IdV18mnPTDBODpS1BXl4ulkFyf1PU2ZmuVGNOIdQwzE=";
    };
  };

  luajit = {
    pname = "luajit";
    version = "2.1-unstable-2023-10-08";

    src = fetchFromGitHub {
      owner = "LuaJIT";
      repo = "LuaJIT";
      rev = "656ecbcf8f669feb94e0d0ec4b4f59190bcd2e48";
      hash = "sha256-/gGQzHgYuWGqGjgpEl18Rbh3Sx2VP+zLlx4N9/hbYLc=";
    };
  };

  tracy = {
    pname = "tracy";
    version = "0.9.1-unstable-2023-10-09";

    src = fetchFromGitHub {
      owner = "wolfpld";
      repo = "tracy";
      rev = "93537dff336e0796b01262e8271e4d63bf39f195";
      hash = "sha256-FNB2zTbwk8hMNmhofz9GMts7dvH9phBRVIdgVjRcyQM=";
    };
  };
}
