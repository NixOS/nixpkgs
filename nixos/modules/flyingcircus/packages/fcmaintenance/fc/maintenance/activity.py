class Activity:

    stdout = None
    stderr = None
    returncode = None

    def __init__(self):
        pass

    def run(self):
        self.returncode = 0

    def load(self, dir):
        pass

    def dump(self, dir):
        pass
