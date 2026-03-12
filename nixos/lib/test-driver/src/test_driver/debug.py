import logging
import os
import random
import shutil
import subprocess
import sys
from abc import ABC, abstractmethod

from remote_pdb import RemotePdb  # type:ignore

from test_driver.logger import AbstractLogger


class DebugAbstract(ABC):
    @abstractmethod
    def breakpoint(self, host: str = "127.0.0.1", port: int = 4444) -> None:
        pass


class DebugNop(DebugAbstract):
    def __init__(self) -> None:
        pass

    def breakpoint(self, host: str = "127.0.0.1", port: int = 4444) -> None:
        pass


class Debug(DebugAbstract):
    def __init__(self, logger: AbstractLogger, attach_command: str) -> None:
        self.breakpoint_on_failure = False
        self.logger = logger
        self.attach = attach_command

    def breakpoint(self, host: str = "127.0.0.1", port: int = 4444) -> None:
        """
        Call this function to stop execution and put the process on sleep while
        at the same time have the test driver provide a debug shell on TCP port
        `port`. This is meant to be used for sandboxed tests that have the test
        driver feature `enableDebugHook` enabled.
        """
        pattern = str(random.randrange(999999, 9999999))
        self.logger.log_test_error(
            f"Breakpoint reached, run 'sudo {self.attach} {pattern}'"
        )
        os.environ["bashInteractive"] = shutil.which("bash")  # type:ignore
        if os.fork() == 0:
            subprocess.run(["sleep", pattern])
        else:
            # RemotePdb writes log messages to both stderr AND the logger,
            # which is the same here. Hence, disabling the remote_pdb logger
            # to avoid duplicate messages in the build log.
            logging.root.manager.loggerDict["remote_pdb"].disabled = True  # type:ignore
            RemotePdb(host=host, port=port).set_trace(sys._getframe().f_back)
