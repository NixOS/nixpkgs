class Estimate:

    def __init__(self, spec):
        self.value = 0
        try:
            self.value = int(spec.total_seconds())
            return
        except (AttributeError, TypeError):
            pass
        try:
            self.value = int(spec)
            return
        except ValueError:
            pass
        try:
            for component in [e.strip() for e in spec.split()]:
                if component.endswith('h'):
                    self.value += int(component[:-1]) * 60 * 60
                elif component.endswith('m'):
                    self.value += int(component[:-1]) * 60
                elif component.endswith('s'):
                    self.value += int(component[:-1])
                else:
                    self.value += int(component)
        except ValueError:
            raise ValueError('invalid estimate specification', spec)

    def __str__(self):
        out = []
        remainder = self.value
        if remainder >= 60 * 60:
            hours = int(remainder / 60 / 60)
            remainder -= hours * 60 * 60
            out.append('{}h'.format(hours))
        if remainder >= 60:
            minutes = int(remainder / 60)
            remainder -= minutes * 60
            out.append('{}m'.format(minutes))
        if remainder:
            out.append('{}s'.format(int(remainder)))
        return ' '.join(out)

    def __int__(self):
        return self.value
