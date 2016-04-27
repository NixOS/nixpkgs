from fc.maintenance.estimate import Estimate

import datetime
import pytest


def test_str_to_estimate():
    for (spec, result) in [
            ('0.7', .7),
            ('3s', 3),
            ('5m', 5 * 60),
            ('3h', 3 * 60 * 60),
            ('6h 4s', 6 * 60 * 60 + 4),
            ('4m 2s', 4 * 60 + 2)]:
        assert float(Estimate(spec)) == result


def test_invalid_str():
    for spec in ['foo', '12h30m', '2d']:
        with pytest.raises(ValueError):
            Estimate(spec)


def test_datetime():
    assert int(Estimate(datetime.timedelta(seconds=224))) == 224


def test_estimate_to_str():
    for (duration, result) in [
            (3302, '55m 2s'),
            (5860, '1h 37m 40s')]:
        assert str(Estimate(duration)) == result


def test_very_short_duration():
    assert str(Estimate(1e-05)) == '1s'


def test_zero_duration():
    assert str(Estimate(0)) == '0s'


def test_repr():
    assert repr(Estimate(42)) == '<Estimate(42.0)>'
