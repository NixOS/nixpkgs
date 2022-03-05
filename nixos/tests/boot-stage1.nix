import ./make-test-python.nix ({ pkgs, ... }: {
  name = "boot-stage1";

  machine = { config, pkgs, lib, ... }: {
    boot.extraModulePackages = let
      compileKernelModule = name: source: pkgs.runCommandCC name rec {
        inherit source;
        kdev = config.boot.kernelPackages.kernel.dev;
        kver = config.boot.kernelPackages.kernel.modDirVersion;
        ksrc = "${kdev}/lib/modules/${kver}/build";
        hardeningDisable = [ "pic" ];
        nativeBuildInputs = kdev.moduleBuildDependencies;
      } ''
        echo "obj-m += $name.o" > Makefile
        echo "$source" > "$name.c"
        make -C "$ksrc" M=$(pwd) modules
        install -vD "$name.ko" "$out/lib/modules/$kver/$name.ko"
      '';

      # This spawns a kthread which just waits until it gets a signal and
      # terminates if that is the case. We want to make sure that nothing during
      # the boot process kills any kthread by accident, like what happened in
      # issue #15226.
      kcanary = compileKernelModule "kcanary" ''
        #include <linux/version.h>
        #include <linux/init.h>
        #include <linux/module.h>
        #include <linux/kernel.h>
        #include <linux/kthread.h>
        #include <linux/sched.h>
        #include <linux/signal.h>
        #if LINUX_VERSION_CODE >= KERNEL_VERSION(4, 10, 0)
        #include <linux/sched/signal.h>
        #endif

        MODULE_LICENSE("GPL");

        struct task_struct *canaryTask;

        static int kcanary(void *nothing)
        {
          allow_signal(SIGINT);
          allow_signal(SIGTERM);
          allow_signal(SIGKILL);
          while (!kthread_should_stop()) {
            set_current_state(TASK_INTERRUPTIBLE);
            schedule_timeout_interruptible(msecs_to_jiffies(100));
            if (signal_pending(current)) break;
          }
          return 0;
        }

        static int kcanaryInit(void)
        {
          kthread_run(&kcanary, NULL, "kcanary");
          return 0;
        }

        static void kcanaryExit(void)
        {
          kthread_stop(canaryTask);
        }

        module_init(kcanaryInit);
        module_exit(kcanaryExit);
      '';

    in lib.singleton kcanary;

    boot.initrd.kernelModules = [ "kcanary" ];

    boot.initrd.extraUtilsCommands = let
      compile = name: source: pkgs.runCommandCC name { inherit source; } ''
        mkdir -p "$out/bin"
        echo "$source" | gcc -Wall -o "$out/bin/$name" -xc -
      '';

      daemonize = name: source: compile name ''
        #include <stdio.h>
        #include <unistd.h>

        void runSource(void) {
        ${source}
        }

        int main(void) {
          if (fork() > 0) return 0;
          setsid();
          runSource();
          return 1;
        }
      '';

      mkCmdlineCanary = { name, cmdline ? "", source ? "" }: (daemonize name ''
        char *argv[] = {"${cmdline}", NULL};
        execvp("${name}-child", argv);
      '') // {
        child = compile "${name}-child" ''
          #include <stdio.h>
          #include <unistd.h>

          int main(void) {
            ${source}
            while (1) sleep(1);
            return 1;
          }
        '';
      };

      copyCanaries = with lib; concatMapStrings (canary: ''
        ${optionalString (canary ? child) ''
          copy_bin_and_libs "${canary.child}/bin/${canary.child.name}"
        ''}
        copy_bin_and_libs "${canary}/bin/${canary.name}"
      '');

    in copyCanaries [
      # Simple canary process which just sleeps forever and should be killed by
      # stage 2.
      (daemonize "canary1" "while (1) sleep(1);")

      # We want this canary process to try mimicking a kthread using a cmdline
      # with a zero length so we can make sure that the process is properly
      # killed in stage 1.
      (mkCmdlineCanary {
        name = "canary2";
        source = ''
          FILE *f;
          f = fopen("/run/canary2.pid", "w");
          fprintf(f, "%d\n", getpid());
          fclose(f);
        '';
      })

      # This canary process mimicks a storage daemon, which we do NOT want to be
      # killed before going into stage 2. For more on root storage daemons, see:
      # https://www.freedesktop.org/wiki/Software/systemd/RootStorageDaemons/
      (mkCmdlineCanary {
        name = "canary3";
        cmdline = "@canary3";
      })
    ];

    boot.initrd.postMountCommands = ''
      canary1
      canary2
      canary3
      # Make sure the pidfile of canary 2 is created so that we still can get
      # its former pid after the killing spree starts next within stage 1.
      while [ ! -s /run/canary2.pid ]; do sleep 0.1; done
    '';
  };

  testScript = ''
    machine.wait_for_unit("multi-user.target")
    machine.succeed("test -s /run/canary2.pid")
    machine.fail("pgrep -a canary1")
    machine.fail("kill -0 $(< /run/canary2.pid)")
    machine.succeed('pgrep -a -f "^@canary3$"')
    machine.succeed('pgrep -a -f "^kcanary$"')
  '';

  meta.maintainers = with pkgs.lib.maintainers; [ aszlig ];
})
