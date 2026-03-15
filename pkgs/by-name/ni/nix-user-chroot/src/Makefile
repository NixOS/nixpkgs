ENV_PATH ?= ""

nix-user-chroot: main.cpp
	${CXX} -o nix-user-chroot -DENV_PATH='$(ENV_PATH)' main.cpp
