class Estimate:

    def __init__(self, spec):
        self.value = 0.0
        try:
            self.value = float(spec.total_seconds())  # timedelta
            return
        except (AttributeError, TypeError):
            pass
        try:
            self.value = float(spec)
            return
        except ValueError:
            pass
        try:
            for component in [e.strip() for e in spec.split()]:
                if component.endswith('h'):
                    self.value += float(component[:-1]) * 60 * 60
                elif component.endswith('m'):
                    self.value += float(component[:-1]) * 60
                elif component.endswith('s'):
                    self.value += float(component[:-1])
                else:
                    self.value += float(component)
        except ValueError:
            raise ValueError('invalid estimate specification', spec)

    def __str__(self):
        if self.value == 0:
            return '0s'
        elif self.value > 0 and self.value < 1:
            return '1s'
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

    def __repr__(self):
        return '<{}({})>'.format(self.__class__.__name__, self.value)

    def __int__(self):
        return int(self.value)

    def __float__(self):
        return float(self.value)
