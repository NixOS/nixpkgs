"""Base class for maintenance activities."""


class Activity:
    """Maintenance activity which is executed as request payload.

    Activities are executed possibly several times until they succeed or
    exceeed their retry limit. Individual maintenance activities should
    subclass this class and add custom behaviour to its methods.
    """

    stdout = None
    stderr = None
    returncode = None

    def __init__(self):
        """Creates activity object (add args if you like).

        Note that this method gets only called once and the value of
        __dict__ is serialized using PyYAML between runs.
        """
        pass

    def run(self):
        """Executes maintenance activity.

        Execution takes place in a request-specific directory as CWD. Do
        whatever you want here, but do not destruct `request.yaml`.
        Directory contents is preserved between several attempts.

        This method is expected to update self.stdout, self.stderr, and
        self.returncode after each run. Request state is determined
        according to the EXIT_* constants in `state.py`. Any returncode
        not listed there means hard failure and causes the request to be
        archived. Uncaught exceptions are handled the same way.
        """
        self.returncode = 0

    def load(self):
        """Loads external state.

        This method gets called every time the Activity object is
        deserialized to perform additional state updating. This should
        be rarely needed, as the contents of self.__dict__ is preserved
        anyway. CWD is set to the request dir.
        """
        pass

    def dump(self):
        """Saves additional state during serialization."""
        pass
