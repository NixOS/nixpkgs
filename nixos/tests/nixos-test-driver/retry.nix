{
  name = "retry";

  nodes = { };

  testScript = ''
    import datetime as dt
    import time

    from test_driver.errors import RequestedAssertionFailed


    unbounded_arguments = []
    retry(
        lambda remaining: unbounded_arguments.append(remaining) or True,
        timeout=None,
    )
    assert unbounded_arguments == [None]

    attempts = 0

    def slow_failure(remaining: float | None) -> bool:
        global attempts
        assert remaining is not None and remaining > 0
        attempts += 1
        time.sleep(0.05)
        return False

    with t.assertRaises(RequestedAssertionFailed):
        retry(slow_failure, timeout=dt.timedelta(seconds=0.01))
    assert attempts == 1

    late_success_attempts = 0

    def late_success(remaining: float | None) -> bool:
        global late_success_attempts
        assert remaining is not None and remaining > 0
        late_success_attempts += 1
        time.sleep(0.02)
        return True

    retry(late_success, timeout=dt.timedelta(seconds=0.01))
    assert late_success_attempts == 1

    zero_timeout_attempts = 0

    def zero_timeout(_remaining: float | None) -> bool:
        global zero_timeout_attempts
        zero_timeout_attempts += 1
        return True

    with t.assertRaises(RequestedAssertionFailed):
        retry(zero_timeout, timeout=dt.timedelta(0))
    assert zero_timeout_attempts == 0
  '';
}
