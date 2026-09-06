import org.apache.activemq.broker.BrokerService;
import org.apache.activemq.broker.BrokerFactory;
import java.net.URI;

public class ActiveMQBroker {

  public static void main(String[] args) throws Throwable {
    URI uri = new URI((args.length > 0) ? args[0] : "xbean:activemq.xml");
    BrokerService broker = BrokerFactory.createBroker(uri);
    broker.start();
    if (broker.waitUntilStarted()) {
      broker.waitUntilStopped();
    } else {
      System.out.println("Failed starting broker");
      System.exit(-1);
    };
  }

}
