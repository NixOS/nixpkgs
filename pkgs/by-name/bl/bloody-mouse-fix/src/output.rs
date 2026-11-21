use super::mapper;

use std::thread::sleep;
use std::time::Duration;
use uinput::device::Builder;
use uinput::Event::{Controller, Relative};
use uinput::event::Controller::Mouse;
use uinput::event::controller::Mouse::{Back, Extra, Forward, Left, Middle, Right, Side, Task};
use uinput::event::Relative::{Position, Wheel};
use uinput::event::relative::Position::{X, Y};
use uinput::event::relative::Wheel::Vertical;

pub fn start_capturing_events(events: Vec<evdev_rs::Device>) {
    let mut output = Builder::open("/dev/uinput")
        .unwrap()
        .name("mouse_fix")
        .unwrap()
        .event(Controller(Mouse(Left)))
        .unwrap()
        .event(Controller(Mouse(Right)))
        .unwrap()
        .event(Controller(Mouse(Middle)))
        .unwrap()
        .event(Controller(Mouse(Side)))
        .unwrap()
        .event(Controller(Mouse(Extra)))
        .unwrap()
        .event(Controller(Mouse(Forward)))
        .unwrap()
        .event(Controller(Mouse(Back)))
        .unwrap()
        .event(Controller(Mouse(Task)))
        .unwrap()
        .event(Relative(Position(X)))
        .unwrap()
        .event(Relative(Position(Y)))
        .unwrap()
        .event(Relative(Wheel(Vertical)))
        .unwrap()
        .create()
        .unwrap();

    loop {
        // read event stream for each detected
        for event in &events {
            if !event.has_event_pending() {
                continue;
            }

            let stream = event.next_event(evdev_rs::ReadFlag::NORMAL).map(|ev| ev.1);
            if let Ok(ev) = stream {
                let org_type = &ev.event_type().unwrap();
                let org_code = &ev.event_code.into();

                if org_type.clone() == evdev_rs::enums::EventType::EV_SYN {
                    output.synchronize().unwrap();
                    continue;
                }

                let event_type = mapper::map_event_type_to_i32(org_type);
                let event_code = mapper::map_key_event_code_to_i32(org_code);

                if event_type.is_some() && event_code.is_some() {
                    let t = event_type.unwrap();
                    let c = event_code.unwrap();

                    output.write(t, c, ev.value).unwrap();
                }
            }
        }

        sleep(Duration::from_micros(100))
    }
}